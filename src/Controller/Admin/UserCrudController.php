<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\User;
use App\Enum\RoleEnum;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserCrudController extends AbstractCrudController
{

    public function __construct(
        private UserPasswordHasherInterface $userPasswordHasher,
    )
    {
    }

    public static function getEntityFqcn(): string
    {
        return User::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return parent::configureCrud($crud)
            ->setPageTitle(Crud::PAGE_INDEX, 'Les utilisateurs')
            ->setPageTitle(Crud::PAGE_NEW, 'Créez un utilisateur')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier un utilisateur');
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->remove(Crud::PAGE_INDEX, Action::NEW)
            ->remove(Crud::PAGE_INDEX, Action::DELETE)
            ->remove(Crud::PAGE_INDEX, Action::EDIT);
    }


    public function configureFields(string $pageName): iterable
    {


        yield TextField::new('email');
        yield TextField::new('name');
        yield TextField::new('firstName');
        yield TextField::new('password')
            ->setFormType(PasswordType::class)
            ->onlyOnForms();
        yield ChoiceField::new('roles')
            ->allowMultipleChoices('true')
            ->setLabel('Rôle de l\'utilisateur')
            ->renderAsBadges([
                'ROLE_USER' => 'success',
                'ROLE_CORRECTOR' => 'primary',
                'ROLE_AUTHOR' => 'warning',
                'ROLE_ADMIN' => 'danger',
            ])
            ->setChoices(RoleEnum::choices());
        yield BooleanField::new('news');
        yield BooleanField::new('articles');
    }

    public function persistEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        /** @var $user */
        $user = $entityInstance;

        $plainPassword = $user->getPAssword();
        $hashedPassword = $this->userPasswordHasher->hashPassword($user, $plainPassword);

        $user->setPassword($hashedPassword);

        parent::persistEntity($entityManager, $entityInstance);
    }

}
