<?php

namespace App\Controller\Admin;

use App\Entity\Site;
use App\Entity\SiteGalleryItem;
use App\Service\SiteContext;
use Doctrine\ORM\EntityManagerInterface;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_FREELANCE')]
class ThemeImagesCrudController extends AbstractCrudController
{
    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return SiteGalleryItem::class;
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->setLabel('Ajouter une image'))
            ->add(Crud::PAGE_INDEX, Action::DETAIL);
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Image du theme')
            ->setEntityLabelInPlural('Images du theme')
            ->setPageTitle(Crud::PAGE_INDEX, 'Images du theme')
            ->setPageTitle(Crud::PAGE_NEW, 'Ajouter une image')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier l\'image')
            ->setDefaultSort(['slot' => 'ASC', 'position' => 'ASC'])
            ->setSearchFields(['title', 'slot', 'content']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Index ---
        yield AssociationField::new('media', 'Image')
            ->setHelp('Selectionnez un media existant depuis la bibliotheque.');

        yield ChoiceField::new('slot', 'Type')
            ->setChoices([
                'Galerie / Portfolio' => 'gallery',
                'Logo client' => 'logo',
                'Temoignage' => 'testimonial',
            ])
            ->renderAsBadges([
                'gallery' => 'primary',
                'logo' => 'info',
                'testimonial' => 'success',
            ]);

        yield TextField::new('title', 'Titre / Nom')
            ->setHelp('Alt text pour les images, nom de la personne pour les temoignages.')
            ->hideOnIndex();

        yield TextareaField::new('content', 'Description / Citation')
            ->setHelp('Texte du temoignage ou description de l\'image.')
            ->hideOnIndex()
            ->setFormTypeOptions(['attr' => ['rows' => 3]]);

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Les elements sont tries par ordre croissant (0 = premier).');
    }

    /**
     * Auto-attach gallery item to current site on creation.
     */
    public function persistEntity(EntityManagerInterface $em, $entityInstance): void
    {
        if ($entityInstance instanceof SiteGalleryItem) {
            $site = $this->siteContext->getCurrentSite();
            if ($site) {
                $entityInstance->setSite($site);
            }
        }

        parent::persistEntity($em, $entityInstance);
    }

    /**
     * Filter gallery items to current site only.
     */
    public function createIndexQueryBuilder(
        $searchDto,
        $entityDto,
        $fields,
        $filters,
    ): \Doctrine\ORM\QueryBuilder {
        $qb = parent::createIndexQueryBuilder($searchDto, $entityDto, $fields, $filters);

        $site = $this->siteContext->getCurrentSite();
        if ($site) {
            $qb->andWhere('entity.site = :site')
                ->setParameter('site', $site);
        }

        return $qb;
    }
}
