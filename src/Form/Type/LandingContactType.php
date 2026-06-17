<?php

namespace App\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\HiddenType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

class LandingContactType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('name', TextType::class, [
                'label' => 'Nom',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer votre nom.'),
                    new Assert\Length(max: 100),
                ],
                'attr' => ['class' => 'form-control', 'placeholder' => 'Votre nom'],
            ])
            ->add('email', EmailType::class, [
                'label' => 'Email',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer votre email.'),
                    new Assert\Email(message: 'Adresse email invalide.'),
                ],
                'attr' => ['class' => 'form-control', 'placeholder' => 'votre@email.com'],
            ])
            ->add('activity', TextType::class, [
                'label' => 'Votre activité',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez indiquer votre activité.'),
                    new Assert\Length(max: 255),
                ],
                'attr' => ['class' => 'form-control', 'placeholder' => 'Ex : Coach, Photographe, Artisan...'],
            ])
            ->add('utm_source', HiddenType::class, [
                'mapped' => false,
                'required' => false,
            ])
            ->add('utm_medium', HiddenType::class, [
                'mapped' => false,
                'required' => false,
            ])
            ->add('utm_campaign', HiddenType::class, [
                'mapped' => false,
                'required' => false,
            ])
            ->add('website', TextType::class, [
                'label' => false,
                'required' => false,
                'mapped' => false,
                'attr' => [
                    'style' => 'position:absolute;left:-9999px',
                    'tabindex' => '-1',
                    'autocomplete' => 'off',
                ],
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([]);
    }
}
