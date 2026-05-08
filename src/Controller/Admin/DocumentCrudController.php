<?php

namespace App\Controller\Admin;

use App\Entity\Document;
use App\Service\DocumentService;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\FormField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Form\Type\FileUploadType;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Symfony\Component\Validator\Constraints\File;

#[IsGranted('ROLE_AUTHOR')]
class DocumentCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public function __construct(
        private readonly DocumentService $documentService,
    ) {
    }

    public static function getEntityFqcn(): string
    {
        return Document::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Documents',
            'sections' => [
                [
                    'title' => 'Ajouter un document',
                    'content' => '<p>Formats acceptes : <strong>PDF, DOC/DOCX, XLS/XLSX, PPT/PPTX, ODT/ODS/ODP, ZIP, RAR, 7Z, CSV, TXT</strong>. Taille maximale : 25 Mo.</p>
                    <p>Le nom saisi est celui qui apparait dans la carte cliquable (et au telechargement).</p>',
                ],
                [
                    'title' => 'Inserer dans un article ou une page',
                    'content' => '<p>Dans l\'editeur, cliquez sur le bouton <strong>Document</strong> de la barre d\'outils, puis selectionnez un document de la bibliotheque ou uploadez-en un nouveau.</p>',
                ],
            ],
            'tips' => [
                'Donnez un nom descriptif (ex : "Plaquette commerciale 2026") plutot que le nom brut du fichier.',
                'Pour les contenus volumineux (videos, archives lourdes), preferez un hebergeur dedie (YouTube, WeTransfer) et un lien externe.',
            ],
        ];
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setPageTitle(Crud::PAGE_INDEX, 'Documents')
            ->setPageTitle(Crud::PAGE_NEW, 'Ajouter un document')
            ->setPageTitle(Crud::PAGE_EDIT, 'Modifier le document')
            ->setDefaultSort(['id' => 'DESC']);
    }

    public function configureFields(string $pageName): iterable
    {
        yield FormField::addPanel('Document')
            ->setIcon('fa fa-file')
            ->collapsible();

        yield TextField::new('name', 'Nom du document')
            ->setHelp('Nom affiche dans la carte (et utilise comme titre lors du telechargement)')
            ->setFormTypeOptions([
                'attr' => ['placeholder' => 'Ex: Plaquette commerciale 2026, CV, Bon de commande...'],
            ]);

        $fileField = TextField::new('fileName', 'Fichier')
            ->setFormType(FileUploadType::class)
            ->setFormTypeOptions([
                'upload_dir' => 'public/documents/files/',
                'upload_filename' => '[slug]-[uuid].[extension]',
                'allow_add' => false,
                'allow_delete' => false,
                'constraints' => [
                    new File(
                        maxSize: DocumentService::MAX_FILE_SIZE_BYTES,
                        extensions: DocumentService::ALLOWED_EXTENSIONS,
                        extensionsMessage: 'Format non autorise. Acceptes : PDF, DOC/DOCX, XLS/XLSX, PPT/PPTX, ODT/ODS/ODP, ZIP, RAR, 7Z, CSV, TXT.',
                    ),
                ],
            ])
            ->setHelp('Taille max : 25 Mo. PDF, Word, Excel, PowerPoint, OpenDocument, archives, CSV, TXT.');

        if (Crud::PAGE_EDIT === $pageName) {
            $fileField->setFormTypeOption('required', false);
        }

        yield $fileField;

        if (Crud::PAGE_INDEX === $pageName || Crud::PAGE_DETAIL === $pageName) {
            yield TextField::new('extension', 'Type')
                ->onlyOnIndex()
                ->formatValue(fn ($value) => $value ? strtoupper((string) $value) : '');

            yield TextField::new('size', 'Taille')
                ->onlyOnIndex()
                ->formatValue(fn ($value) => $value !== null ? $this->documentService->formatSize((int) $value) : '');

            yield DateTimeField::new('createdAt', 'Ajoute le')
                ->setFormat('dd/MM/yyyy HH:mm')
                ->onlyOnIndex();
        }
    }
}
