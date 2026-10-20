<?php

namespace App\Controller\Admin;

use App\Entity\Media;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Router\AdminUrlGenerator;
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
                    'content' => '<p>Le champ <em>Texte alternatif</em> decrit ce que montre l\'image. Il est important pour :</p>
                    <ul>
                        <li><strong>L\'accessibilite</strong> — les lecteurs d\'ecran le lisent aux malvoyants</li>
                        <li><strong>Le SEO</strong> — Google comprend le contenu de vos images grace a ce texte</li>
                    </ul>
                    <p>S\'il est vide, le site construit un texte a partir du <em>Nom</em> du media et du titre de la page. L\'analyse SEO signale les images concernees.</p>',
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
            ->setPageTitle(Crud::PAGE_INDEX, 'Médias')
            ->setPageTitle(Crud::PAGE_NEW, 'Ajouter une image')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier l\'image')
            // Medias et documents sont deux onglets d'un meme espace "Medias"
            ->setHelp(Crud::PAGE_INDEX, 'Images de votre site. Pour les fichiers à télécharger (PDF, plaquettes) : <a href="'
                . $this->container->get(AdminUrlGenerator::class)->unsetAll()->setController(DocumentCrudController::class)->setAction(Action::INDEX)->generateUrl()
                . '">Documents</a>.')
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->update(Crud::PAGE_INDEX, Action::NEW, fn (Action $action) => $action->setLabel('Ajouter une image'));
    }

    public function configureFields(string $pageName): iterable
    {
        // --- Panel Fichier ---
        yield FormField::addPanel('Fichier')
            ->setIcon('fa fa-image')
            ->collapsible();

        yield TextField::new('name', 'Nom du media')
            ->setHelp('Nom descriptif pour identifier le media dans la bibliotheque')
            ->setFormTypeOptions([
                'attr' => ['placeholder' => 'Ex: Photo equipe, Logo client, Banniere article...'],
            ]);

        yield TextField::new('alt', 'Texte alternatif')
            ->setHelp('Decrivez ce que montre l\'image, en une phrase courte. Lu par les lecteurs d\'ecran et par Google. Si vide, le nom du media est utilise.')
            ->setRequired(false)
            ->setFormTypeOptions([
                'attr' => ['placeholder' => 'Ex: L\'equipe reunie autour d\'une table dans les bureaux de Pau', 'maxlength' => 255],
            ])
            ->hideOnIndex();

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
