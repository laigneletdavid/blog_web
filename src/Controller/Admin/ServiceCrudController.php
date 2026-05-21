<?php

namespace App\Controller\Admin;

use App\Entity\Service;
use App\Field\IconPickerField;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\IntegerField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class ServiceCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;
    use Trait\SlugFieldHelperTrait;

    public static function getEntityFqcn(): string
    {
        return Service::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Services')
            ->setPageTitle(Crud::PAGE_NEW, 'Nouveau service')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier le service')
            ->setDefaultSort(['position' => 'ASC']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Contenu ---
        yield FormField::addPanel('Contenu')
            ->setIcon('fa fa-pen')
            ->collapsible();

        yield TextField::new('title', 'Titre');

        yield TextareaField::new('shortDescription', 'Description courte')
            ->setHelp('Affichée dans la grille des services sur la page d\'accueil.')
            ->setFormTypeOptions(['attr' => ['rows' => 3]])
            ->hideOnIndex();

        yield TextareaField::new('blocksJson', 'Contenu détaillé')
            ->setFormTypeOptions(['attr' => ['data-tiptap-editor' => '', 'style' => 'display: none']])
            ->setColumns('col-12')
            ->setHelp('Page de detail du service (editeur visuel, optionnel). Tapez <strong>/</strong> pour inserer un bloc. Si vide, pas de page detail.')
            ->hideOnIndex();

        yield IconPickerField::new('icon', 'Icône')
            ->hideOnIndex();

        yield AssociationField::new('image', 'Image')
            ->hideOnIndex();

        // --- Panel Paramètres ---
        yield FormField::addPanel('Paramètres')
            ->setIcon('fa fa-cog')
            ->collapsible();

        yield $this->slugField('title');

        yield AssociationField::new('linkedPage', 'Page liée')
            ->setHelp('Lier ce service à une page du site (prioritaire sur le lien externe)')
            ->hideOnIndex();

        yield TextField::new('link', 'Lien externe')
            ->setHelp('URL externe (utilisé uniquement si pas de page liée ni de contenu détaillé)')
            ->hideOnIndex();

        yield IntegerField::new('position', 'Ordre')
            ->setHelp('Ordre d\'affichage (0 = premier)');

        yield BooleanField::new('isActive', 'Actif');

        // --- Panel SEO ---
        yield FormField::addPanel('SEO')
            ->setIcon('fa fa-search')
            ->collapsible()
            ->renderCollapsed();

        yield TextField::new('seoTitle', 'Titre SEO')
            ->setHelp('Apparait dans l\'onglet du navigateur et comme titre dans Google. Max 70 caracteres. Laissez vide = titre du service.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 70]])
            ->hideOnIndex();

        yield TextareaField::new('seoDescription', 'Meta description')
            ->setHelp('Texte affiche sous le titre dans les resultats Google. Max 160 caracteres.')
            ->setFormTypeOptions(['attr' => ['maxlength' => 160, 'rows' => 3]])
            ->hideOnIndex();

        yield TextField::new('seoKeywords', 'Mots-cles')
            ->setHelp('Mots-cles du service, separes par des virgules.')
            ->hideOnIndex();

        yield BooleanField::new('noIndex', 'Masquer des moteurs')
            ->setHelp('Si active, Google n\'indexera pas ce service.')
            ->hideOnIndex();

        yield TextField::new('canonicalUrl', 'URL canonique')
            ->setHelp('A remplir uniquement si ce contenu existe aussi sur un autre site. Laissez vide sinon.')
            ->hideOnIndex();
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Services',
            'sections' => [
                [
                    'title' => 'Fiches de services',
                    'content' => '<p>Presentez vos prestations sous forme de grille sur la page d\'accueil.</p>
                    <ul>
                        <li><strong>Description courte</strong> — affichee dans la carte du service</li>
                        <li><strong>Contenu detaille</strong> — page de detail optionnelle (editeur visuel)</li>
                        <li><strong>Icone</strong> — classe Bootstrap Icons (ex: <code>bi-rocket</code>)</li>
                    </ul>',
                ],
                [
                    'title' => 'Liens',
                    'content' => '<p>Priorite des liens : page liee > lien externe > page de detail auto-generee (si contenu detaille rempli).</p>',
                ],
            ],
            'tips' => [
                'L\'icone s\'affiche dans la grille des services sur la home. Trouvez les icones sur icons.getbootstrap.com.',
                '<strong>SEO</strong> : chaque service a sa propre page. Pensez à remplir le Titre SEO (max 70 car.) et la Meta description (max 160 car.) dans le panel SEO pour un meilleur référencement.',
            ],
        ];
    }
}
