<?php

namespace App\Controller\Admin;

use App\Entity\User;
use App\Enum\RoleEnum;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\KeyValueStore;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Dto\EntityDto;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\Form\FormEvent;
use Symfony\Component\Form\FormEvents;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Symfony\Component\Validator\Constraints\Length;
use Symfony\Component\Validator\Constraints\NotBlank;

/**
 * Comptes du site. Un admin voit la liste ; seul le super admin cree et
 * modifie les comptes, admins compris. Pas de suppression depuis l'admin.
 */
#[IsGranted('ROLE_ADMIN')]
class UserCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    private const PASSWORD_MIN = 12;

    public function __construct(
        private readonly UserPasswordHasherInterface $userPasswordHasher,
        private readonly SiteContext $siteContext,
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
                    'title' => 'Créer un compte',
                    'content' => '<p>Réservé au super admin. Renseignez l\'e-mail, le prénom, le nom, le rôle et un mot de passe provisoire d\'au moins <strong>12 caractères</strong>, à transmettre à la personne par un autre canal que l\'e-mail.</p>
                    <p>Le compte est utilisable tout de suite, sans e-mail de vérification. La personne peut ensuite changer son mot de passe depuis son profil, ou via « Mot de passe oublié ».</p>
                    <p>Pour modifier un compte, laissez le mot de passe vide : il reste inchangé.</p>',
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
            ->remove(Crud::PAGE_INDEX, Action::DELETE)
            ->setPermission(Action::NEW, 'ROLE_SUPER_ADMIN')
            ->setPermission(Action::EDIT, 'ROLE_SUPER_ADMIN')
            ->setPermission(Action::DELETE, 'ROLE_SUPER_ADMIN');
    }

    public function configureFields(string $pageName): iterable
    {
        yield TextField::new('email', 'E-mail');
        yield TextField::new('firstName', 'Prénom');
        yield TextField::new('name', 'Nom');

        // Champ hors entite : le mot de passe saisi n'est jamais ecrit tel
        // quel, il est hache a la soumission (voir hashPlainPassword)
        $isNew = $pageName === Crud::PAGE_NEW;
        $constraints = [new Length(min: self::PASSWORD_MIN, minMessage: 'Le mot de passe doit faire au moins {{ limit }} caractères.')];
        if ($isNew) {
            $constraints[] = new NotBlank(message: 'Choisissez un mot de passe provisoire.');
        }
        yield TextField::new('plainPassword', $isNew ? 'Mot de passe provisoire' : 'Nouveau mot de passe')
            ->setFormType(PasswordType::class)
            ->setFormTypeOptions([
                'mapped' => false,
                'required' => $isNew,
                'constraints' => $constraints,
                'attr' => ['autocomplete' => 'new-password'],
            ])
            ->setHelp($isNew
                ? 'Au moins ' . self::PASSWORD_MIN . ' caractères. À transmettre à la personne, qui pourra le changer.'
                : 'Laissez vide pour garder le mot de passe actuel.')
            ->onlyOnForms();

        yield ChoiceField::new('roles')
            ->allowMultipleChoices()
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

    public function createNewFormBuilder(EntityDto $entityDto, KeyValueStore $formOptions, AdminContext $context): FormBuilderInterface
    {
        return $this->hashPlainPassword(parent::createNewFormBuilder($entityDto, $formOptions, $context));
    }

    public function createEditFormBuilder(EntityDto $entityDto, KeyValueStore $formOptions, AdminContext $context): FormBuilderInterface
    {
        return $this->hashPlainPassword(parent::createEditFormBuilder($entityDto, $formOptions, $context));
    }

    public function persistEntity(EntityManagerInterface $entityManager, $entityInstance): void
    {
        // Cree par le super admin : l'adresse n'a pas a etre verifiee par e-mail
        if ($entityInstance instanceof User) {
            $entityInstance->setIsVerified(true);
        }
        parent::persistEntity($entityManager, $entityInstance);
    }

    private function hashPlainPassword(FormBuilderInterface $formBuilder): FormBuilderInterface
    {
        return $formBuilder->addEventListener(FormEvents::POST_SUBMIT, function (FormEvent $event): void {
            $form = $event->getForm();
            $user = $form->getData();
            $plain = $form->has('plainPassword') ? $form->get('plainPassword')->getData() : null;

            if (!$form->isValid() || !$user instanceof User || $plain === null || $plain === '') {
                return;
            }

            $user->setPassword($this->userPasswordHasher->hashPassword($user, $plain));
        });
    }
}
