<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use ContainerCxexD47\getCategorieRepositoryService;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class ArticleCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Article::class;
    }

    public function configureFields(string $pageName): iterable
    {

        yield TextField::new('title', 'Titre de l\'article');
        yield SlugField::new('slug')
            ->setTargetFieldName('title');
        yield AssociationField::new('categories')
            ->setLabel('Catégorie')
            ->formatValue(function (int $count, Article $article) {
                return $article->getCategories()->map(fn (Categorie $category) => $category->getName());
            });
        Yield AssociationField::new('featured_media', 'Média');
        yield TextField::new('featured_text', 'Texte mis en avant');
        yield TextEditorField::new('content', 'Contenu de l\'article')
            ->hideOnIndex();
        yield DateTimeField::new('created_at', 'Date de création')
            ->hideOnForm();
        yield DateTimeField::new('updated_at', 'Date de modification')
            ->hideOnForm();
        yield BooleanField::new('published', 'Publié oui/non');
        yield DateTimeField::new('published_at', 'Date de publication');
    }
}
