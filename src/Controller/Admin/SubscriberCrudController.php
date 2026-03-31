<?php

namespace App\Controller\Admin;

use App\Entity\Subscriber;
use App\Service\SiteContext;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\EmailField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\BooleanFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class SubscriberCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Subscriber::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Abonnes',
            'icon' => 'fas fa-envelope',
            'sections' => [
                [
                    'title' => 'Abonnements email',
                    'content' => 'Les abonnes sont des visiteurs qui ont donne leur email pour recevoir vos actualites. '
                        . 'Ils n\'ont pas besoin de compte utilisateur. '
                        . 'Le systeme utilise le double opt-in : l\'abonne doit confirmer son email avant de recevoir des notifications.',
                ],
                [
                    'title' => 'Gestion',
                    'content' => 'Vous pouvez desactiver un abonne (isActive) pour arreter les envois sans supprimer ses donnees. '
                        . 'La suppression est definitive. '
                        . 'Chaque email de notification contient un lien de desinscription automatique.',
                ],
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Abonne')
            ->setEntityLabelInPlural('Abonnes')
            ->setPageTitle(Crud::PAGE_INDEX, 'Abonnes email')
            ->setPageTitle(Crud::PAGE_DETAIL, fn (Subscriber $subscriber) => $subscriber->getEmail())
            ->setDefaultSort(['createdAt' => 'DESC'])
            ->setSearchFields(['email'])
            ->showEntityActionsInlined();
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->disable(Action::NEW)
            ->add(Crud::PAGE_INDEX, Action::DETAIL);
    }

    public function configureFilters(Filters $filters): Filters
    {
        $f = $filters
            ->add(BooleanFilter::new('isActive')->setLabel('Actif'));

        if ($this->siteContext->hasModule('blog')) {
            $f->add(BooleanFilter::new('subscribeArticles')->setLabel('Articles'));
        }
        if ($this->siteContext->hasModule('events')) {
            $f->add(BooleanFilter::new('subscribeEvents')->setLabel('Evenements'));
        }

        return $f;
    }

    public function configureFields(string $pageName): iterable
    {
        yield EmailField::new('email');

        if ($this->siteContext->hasModule('blog')) {
            yield BooleanField::new('subscribeArticles', 'Articles');
        }

        if ($this->siteContext->hasModule('events')) {
            yield BooleanField::new('subscribeEvents', 'Evenements');
        }

        yield BooleanField::new('isActive', 'Actif')
            ->renderAsSwitch(true);

        yield DateTimeField::new('createdAt', 'Inscrit le')
            ->setFormat('dd/MM/yyyy HH:mm')
            ->hideOnForm();

        yield DateTimeField::new('confirmedAt', 'Confirme le')
            ->setFormat('dd/MM/yyyy HH:mm')
            ->onlyOnDetail();

        yield TextField::new('token')
            ->onlyOnDetail()
            ->setHelp('Token unique pour la confirmation et la desinscription.');
    }
}
