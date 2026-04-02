<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\User;
use App\Enum\RoleEnum;
use App\Service\SiteContext;
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
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class UserCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public function __construct(
        private UserPasswordHasherInterface $userPasswordHasher,
        private SiteContext $siteContext,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return User::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Utilisateurs',
            'sections' => [
                [
                    'title' => 'Les roles',
                    'content' => '<ul>
                        <li><strong>ROLE_USER (Utilisateur)</strong> — Visiteur inscrit : lecture, commentaires, profil, annuaire.</li>
                        <li><strong>ROLE_AUTHOR (Auteur)</strong> — Redacteur : articles, pages, medias (creation/edition).</li>
                        <li><strong>ROLE_ADMIN (Admin)</strong> — Admin client : gestion complete du site (users, menus, categories, tags, config).</li>
                        <li><strong>ROLE_FREELANCE (Freelance)</strong> — Revendeur : themes, couleurs, polices + tout ce que fait Admin.</li>
                        <li><strong>ROLE_SUPER_ADMIN (Super Admin)</strong> — Acces total : modules, infra, configuration avancee.</li>
                    </ul>',
                ],
                [
                    'title' => 'Creer un utilisateur',
                    'content' => '<p>Renseignez l\'email, le prenom, le nom et un mot de passe temporaire. L\'utilisateur pourra le changer depuis son profil.</p>
                    <p>Le mot de passe doit faire au moins <strong>12 caracteres</strong>.</p>',
                ],
                [
                    'title' => 'Annuaire',
                    'content' => '<p>Si le module annuaire est actif, cochez <em>Visible dans l\'annuaire</em> pour que l\'utilisateur apparaisse dans l\'annuaire public du site.</p>',
                ],
            ],
            'tips' => [
                'Creez un compte Auteur pour vos redacteurs. Ils pourront ecrire sans acceder aux reglages sensibles.',
            ],
        ];
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
                'ROLE_AUTHOR' => 'warning',
                'ROLE_ADMIN' => 'danger',
                'ROLE_FREELANCE' => 'info',
                'ROLE_SUPER_ADMIN' => 'dark',
            ])
            ->setChoices(RoleEnum::choices());

        if ($this->siteContext->hasModule('directory')) {
            yield BooleanField::new('isDirectoryVisible', 'Visible dans l\'annuaire')
                ->setHelp('Rend ce membre visible dans l\'annuaire public du site');
            yield TextField::new('company', 'Entreprise')
                ->hideOnIndex();
            yield TextField::new('jobTitle', 'Poste')
                ->hideOnIndex();
            yield TextField::new('phone', 'Telephone')
                ->hideOnIndex();
        }
    }

    public function persistEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        $this->hashPassword($entityInstance);
        parent::persistEntity($entityManager, $entityInstance);
    }

    public function updateEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        $this->hashPassword($entityInstance);
        parent::updateEntity($entityManager, $entityInstance);
    }

    private function hashPassword(object $user): void
    {
        if (!$user instanceof User) {
            return;
        }

        $plainPassword = $user->getPassword();
        if ($plainPassword) {
            $user->setPassword(
                $this->userPasswordHasher->hashPassword($user, $plainPassword)
            );
        }
    }
}
