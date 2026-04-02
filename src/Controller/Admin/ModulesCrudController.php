<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use App\Enum\ModuleEnum;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
use EasyCorp\Bundle\EasyAdminBundle\Context\AdminContext;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Doctrine\ORM\EntityManagerInterface;

#[IsGranted('ROLE_SUPER_ADMIN')]
class ModulesCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return Site::class;
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->disable(Action::NEW, Action::DELETE, Action::BATCH_DELETE, Action::INDEX);
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Modules')
            ->setEntityLabelInPlural('Modules')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modules du site');
    }

    public function configureFields(string $pageName): iterable
    {
        yield ChoiceField::new('enabledModules', 'Modules actifs')
            ->setChoices(ModuleEnum::choices())
            ->allowMultipleChoices()
            ->renderExpanded()
            ->setHelp('Selectionnez les fonctionnalites a activer sur ce site.');
    }

    public function updateEntity(EntityManagerInterface $em, $entityInstance): void
    {
        parent::updateEntity($em, $entityInstance);
    }

    protected function getRedirectResponseAfterSave(AdminContext $context, string $action): RedirectResponse
    {
        $url = $this->container->get(AdminUrlGenerator::class)
            ->setController(self::class)
            ->setAction(Action::EDIT)
            ->setEntityId($context->getEntity()->getPrimaryKeyValue())
            ->generateUrl();

        return $this->redirect($url);
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Modules',
            'sections' => [
                [
                    'title' => 'Activer des fonctionnalites',
                    'content' => '<p>Chaque module ajoute des fonctionnalites au site :</p>
                    <ul>
                        <li><strong>Blog</strong> — articles, categories, tags, commentaires</li>
                        <li><strong>Services</strong> — fiches de prestations</li>
                        <li><strong>Catalogue</strong> — fiches produits avec variantes et tarifs</li>
                        <li><strong>E-commerce</strong> — panier, commandes, paiement Stripe</li>
                        <li><strong>Evenements</strong> — agenda avec evenements a venir et passes</li>
                        <li><strong>Annuaire</strong> — annuaire des membres</li>
                        <li><strong>FAQ</strong> — foire aux questions en accordeon</li>
                        <li><strong>Portfolio</strong> — realisations et projets clients</li>
                    </ul>',
                ],
            ],
            'tips' => [
                'Activez uniquement les modules dont votre client a besoin — le menu s\'adapte automatiquement.',
            ],
        ];
    }
}
