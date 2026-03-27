<?php

namespace App\Controller\Admin;

use App\Entity\Media;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ImageField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_AUTHOR')]
class MediaCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return Media::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Medias',
            'sections' => [
                [
                    'title' => 'Ajouter une image',
                    'content' => '<p>Formats acceptes : <strong>JPG, PNG, GIF, WebP</strong>. Taille maximale : 25 Mo.</p>
                    <p>Chaque image est automatiquement convertie en <strong>WebP</strong> (format plus leger) et declinee en <strong>3 tailles</strong> (480px, 800px, 1200px) pour s\'adapter a tous les ecrans.</p>',
                ],
                [
                    'title' => 'Texte alternatif (alt)',
                    'content' => '<p>Le champ <em>Nom</em> sert de texte alternatif. Il est important pour :</p>
                    <ul>
                        <li><strong>L\'accessibilite</strong> — les lecteurs d\'ecran le lisent aux malvoyants</li>
                        <li><strong>Le SEO</strong> — Google comprend le contenu de vos images grace a ce texte</li>
                    </ul>',
                ],
                [
                    'title' => 'Utiliser un media',
                    'content' => '<p>Les medias sont utilises dans vos articles et pages via le bouton <strong>Image</strong> de l\'editeur, ou comme <em>image mise en avant</em> dans les formulaires.</p>',
                ],
            ],
            'tips' => [
                'Donnez des noms descriptifs a vos images. Preferez "equipe-reunion-bureau" a "IMG_20240315.jpg".',
                'Les images WebP se chargent 25 a 30% plus vite que les JPEG classiques.',
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Medias')
            ->setPageTitle(Crud::PAGE_NEW, 'Ajouter un media')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier le media')
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Fichier ---
        yield FormField::addPanel('Fichier')
            ->setIcon('fa fa-image')
            ->collapsible();

        yield TextField::new('name', 'Nom du media')
            ->setHelp('Nom descriptif pour identifier le media (aussi utilise comme attribut alt)')
            ->setFormTypeOptions([
                'attr' => ['placeholder' => 'Ex: Photo equipe, Logo client, Banniere article...'],
            ]);

        $mediaField = ImageField::new('filename', 'Image')
            ->setBasePath('documents/medias/')
            ->setUploadDir('public/documents/medias/')
            ->setUploadedFileNamePattern('[slug]-[uuid].[extension]')
            ->setHelp('Formats acceptes : JPG, PNG, GIF, WebP. Taille max : 25 Mo.');

        if (Crud::PAGE_EDIT === $pageName) {
            $mediaField->setRequired(false);
        }

        yield $mediaField;

        yield TextField::new('webpFileName', 'WebP')
            ->hideOnForm();
    }
}
