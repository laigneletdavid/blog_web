<?php

namespace App\Command;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

#[AsCommand(
    name: 'app:create-super-admin',
    description: 'Create a super admin user',
)]
class CreateSuperAdminCommand extends Command
{
    public function __construct(
        private readonly EntityManagerInterface $em,
        private readonly UserPasswordHasherInterface $hasher,
    ) {
        parent::__construct();
    }

    protected function configure(): void
    {
        $this
            ->addOption('email', null, InputOption::VALUE_REQUIRED, 'Admin email')
            ->addOption('password', null, InputOption::VALUE_REQUIRED, 'Admin password (min 12 characters)')
            ->addOption('first-name', null, InputOption::VALUE_REQUIRED, 'First name', '')
            ->addOption('last-name', null, InputOption::VALUE_REQUIRED, 'Last name', '')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        // Email: option or interactive
        $email = $input->getOption('email') ?? $io->ask('Email');
        if (!$email) {
            $io->error('Email is required.');
            return Command::FAILURE;
        }

        $existing = $this->em->getRepository(User::class)->findOneBy(['email' => $email]);
        if ($existing) {
            $io->error("User $email already exists.");
            return Command::FAILURE;
        }

        // Password: option or interactive
        $password = $input->getOption('password');
        if (!$password) {
            $password = $io->askHidden('Password (min 12 characters)');
            if (!$password || strlen($password) < 12) {
                $io->error('Password must be at least 12 characters.');
                return Command::FAILURE;
            }

            $confirm = $io->askHidden('Confirm password');
            if ($password !== $confirm) {
                $io->error('Passwords do not match.');
                return Command::FAILURE;
            }
        } elseif (strlen($password) < 12) {
            $io->error('Password must be at least 12 characters.');
            return Command::FAILURE;
        }

        $name = $input->getOption('last-name') ?: ($input->getOption('last-name') === '' ? '' : $io->ask('Last name', ''));
        $firstName = $input->getOption('first-name') ?: ($input->getOption('first-name') === '' ? '' : $io->ask('First name', ''));

        $user = new User();
        $user->setEmail($email);
        $user->setRoles(['ROLE_SUPER_ADMIN']);
        $user->setPassword($this->hasher->hashPassword($user, $password));
        $user->setName($name);
        $user->setFirstName($firstName);

        $this->em->persist($user);
        $this->em->flush();

        $io->success("Super admin $email created.");

        return Command::SUCCESS;
    }
}
