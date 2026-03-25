<?php

namespace App\Form;

use App\Entity\User;
use App\Service\SiteContext;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class UserType extends AbstractType
{
    public function __construct(
        private readonly SiteContext $siteContext,
    ) {
    }

    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('email', EmailType::class, ['label' => 'Votre adresse email'])
            ->add('name', TextType::class, ['label' => 'Votre nom'])
            ->add('first_name', TextType::class, ['label' => 'Votre prénom'])
            ->add('subscribeNews', CheckboxType::class, [
                'required' => false,
                'label' => 'Recevoir la newsletter',
            ])
            ->add('subscribeArticles', CheckboxType::class, [
                'required' => false,
                'label' => 'Recevoir les notifications de nouveaux articles',
            ]);

        if ($this->siteContext->hasModule('events')) {
            $builder->add('subscribeEvents', CheckboxType::class, [
                'required' => false,
                'label' => 'Recevoir les notifications de nouveaux événements',
            ]);
        }
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => User::class,
        ]);
    }
}
