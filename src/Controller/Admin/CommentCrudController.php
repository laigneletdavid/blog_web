<?php

namespace App\Controller\Admin;

use App\Entity\Article;
use App\Entity\Comment;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\AssociationField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;

class CommentCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return Comment::class;
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Commentaires',
            'sections' => [
                [
                    'title' => 'Moderation',
                    'content' => '<p>Les commentaires sont laisses par vos visiteurs connectes sous les articles. Cette page vous permet de les <strong>consulter</strong> et <strong>supprimer</strong> si necessaire.</p>
                    <p>Vous ne pouvez pas creer ni editer de commentaires depuis l\'admin — ils sont laisses uniquement par les utilisateurs du site.</p>',
                ],
                [
                    'title' => 'Interaction',
                    'content' => '<p>Repondre aux commentaires montre que vous etes actif et attentif a vos visiteurs. Cela ameliore l\'engagement et la fidelisation.</p>',
                ],
            ],
            'tips' => [
                'Consultez regulierement les commentaires pour interagir avec vos lecteurs et moderer les contenus inappropries.',
            ],
        ];
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->remove(Crud::PAGE_INDEX, Action::NEW)
            ->remove(Crud::PAGE_INDEX, Action::EDIT);
    }


    public function configureFields(string $pageName): iterable
    {
        yield TextareaField::new('content',);
        yield AssociationField::new('article');
        yield DateTimeField::new('createdAt');
        yield AssociationField::new('user');
    }

}
