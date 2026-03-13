<?php

namespace App\Form\Type;

use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

class ContactType extends AbstractType
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
                'attr' => ['class' => 'form-control'],
            ])
            ->add('firstname', TextType::class, [
                'label' => 'Prénom',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer votre prénom.'),
                    new Assert\Length(max: 100),
                ],
                'attr' => ['class' => 'form-control'],
            ])
            ->add('email', EmailType::class, [
                'label' => 'Email',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer votre email.'),
                    new Assert\Email(message: 'Adresse email invalide.'),
                ],
                'attr' => ['class' => 'form-control'],
            ])
            ->add('subject', TextType::class, [
                'label' => 'Sujet',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer un sujet.'),
                    new Assert\Length(max: 255),
                ],
                'attr' => ['class' => 'form-control'],
            ])
            ->add('message', TextareaType::class, [
                'label' => 'Votre message',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer votre message.'),
                    new Assert\Length(min: 10, max: 5000, minMessage: 'Le message doit contenir au moins {{ limit }} caractères.'),
                ],
                'attr' => ['class' => 'form-control', 'rows' => 6, 'placeholder' => 'Votre message ...'],
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([]);
    }
}
