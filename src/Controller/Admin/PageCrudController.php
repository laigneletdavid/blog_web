<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Categorie;
use App\Entity\Page;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\BooleanField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\SlugField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextEditorField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;

class PageCrudController extends AbstractCrudController
{
    public static function getEntityFqcn(): string
    {
        return Page::class;
    }

    public function configureFields(string $pageName): iterable
    {

        yield TextField::new('title');
        yield SlugField::new('slug')
            ->setTargetFieldName('title');
        Yield AssociationField::new('featured_media');
        yield TextEditorField::new('content')
            ->hideOnIndex();
        yield DateTimeField::new('created_at')
            ->hideOnForm();
        yield DateTimeField::new('updated_at')
            ->hideOnForm();
        yield BooleanField::new('published');
    }
}
