<?php

namespace App\Form;

use App\Entity\User;
use App\Enum\RoleEnum;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\PasswordType;
use Symfony\Component\Form\Extension\Core\Type\RepeatedType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;

class UserType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder


            ->add('email', EmailType::class, ['label' => 'Votre adresse email'])
            ->add('name', TextType::class, ['label' => 'Votre nom'])
            ->add('first_name', TextType::class, ['label' => 'Votre prénom'])
            ->add('news', ChoiceType::class, [
                'choices' => [
                    'Oui'=> true ,
                    'Non' => false,
                ],
                'expanded' => true,
                'multiple' => false,
                'label' => 'Abonnez-vous à la newsletter'
            ])
            ->add('articles', ChoiceType::class, [
                'choices' => [
                    'Oui'=> true ,
                    'Non' => false,
                    ],
                'expanded' => true,
                'multiple' => false,
                'label' => 'Recevez une notification pour les nouveau articles'

            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => User::class,
        ]);
    }
}
