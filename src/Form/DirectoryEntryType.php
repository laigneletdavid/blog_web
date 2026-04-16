<?php

namespace App\Form;

use App\Entity\DirectoryEntry;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\UrlType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints\File;

class DirectoryEntryType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('firstName', TextType::class, ['label' => 'Prenom', 'required' => true])
            ->add('lastName', TextType::class, ['label' => 'Nom', 'required' => true])
            ->add('jobTitle', TextType::class, ['label' => 'Poste / Metier', 'required' => false])
            ->add('company', TextType::class, [
                'label' => 'Entreprise',
                'required' => true,
                'help' => 'Sert a generer l\'URL de votre fiche (slug).',
            ])
            ->add('blocksJson', TextareaType::class, [
                'label' => 'Biographie',
                'required' => false,
                'attr' => [
                    'data-tiptap-editor' => '',
                    'style' => 'display: none',
                ],
            ])
            ->add('email', TextType::class, ['label' => 'Email de contact', 'required' => false])
            ->add('phone', TextType::class, ['label' => 'Telephone', 'required' => false])
            ->add('city', TextType::class, ['label' => 'Ville', 'required' => false])
            ->add('website', UrlType::class, ['label' => 'Site web', 'required' => false])
            ->add('linkedin', UrlType::class, ['label' => 'LinkedIn', 'required' => false])
            ->add('facebook', UrlType::class, ['label' => 'Facebook', 'required' => false])
            ->add('instagram', UrlType::class, ['label' => 'Instagram', 'required' => false])
            ->add('photoFile', FileType::class, [
                'label' => 'Photo',
                'mapped' => false,
                'required' => false,
                'constraints' => [
                    new File([
                        'maxSize' => '5M',
                        'mimeTypes' => ['image/jpeg', 'image/png', 'image/webp'],
                        'mimeTypesMessage' => 'Format accepte : JPG, PNG ou WebP.',
                    ]),
                ],
            ]);
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => DirectoryEntry::class,
        ]);
    }
}
