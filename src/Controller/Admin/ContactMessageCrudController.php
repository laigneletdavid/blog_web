<?php

namespace App\Controller\Admin;

use App\Entity\ContactMessage;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\EmailField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\BooleanFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\DateTimeFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class ContactMessageCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return ContactMessage::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Messages de contact',
            'sections' => [
                [
                    'title' => 'Messages recus',
                    'content' => '<p>Chaque formulaire de contact soumis par un visiteur est stocke ici. Vous pouvez <strong>consulter</strong> les messages et les <strong>marquer comme lus</strong>.</p>
                    <p>L\'email est toujours envoye en parallele — cette page est un archivage complementaire.</p>',
                ],
            ],
            'tips' => [
                'Les messages non lus apparaissent en premier. Cliquez sur un message pour voir le detail complet.',
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Message')
            ->setEntityLabelInPlural('Messages de contact')
            ->setDefaultSort(['createdAt' => 'DESC'])
            ->setSearchFields(['name', 'firstname', 'email', 'subject', 'message'])
            ->setPageTitle(Crud::PAGE_INDEX, 'Messages de contact');
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->remove(Crud::PAGE_INDEX, Action::NEW)
            ->remove(Crud::PAGE_INDEX, Action::EDIT)
            ->remove(Crud::PAGE_DETAIL, Action::EDIT)
            ->add(Crud::PAGE_INDEX, Action::DETAIL);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(BooleanFilter::new('isRead', 'Lu'))
            ->add(DateTimeFilter::new('createdAt', 'Date'));
    }

    public function configureFields(string $pageName): iterable
    {
        yield BooleanField::new('isRead', 'Lu')
            ->renderAsSwitch(true);
        yield TextField::new('fullName', 'Nom')
            ->hideOnForm()
            ->onlyOnIndex();
        yield TextField::new('firstname', 'Prenom')
            ->onlyOnDetail();
        yield TextField::new('name', 'Nom')
            ->onlyOnDetail();
        yield EmailField::new('email', 'Email');
        yield TextField::new('subject', 'Sujet');
        yield TextareaField::new('message', 'Message')
            ->onlyOnDetail()
            ->renderAsHtml();
        yield TextField::new('sourcePage', 'Page source')
            ->onlyOnDetail();
        yield DateTimeField::new('createdAt', 'Recu le')
            ->setFormat('dd/MM/yyyy HH:mm');
    }
}
