<?php

namespace App\Form\Type;

use App\Entity\Subscriber;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\CheckboxType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

class SubscribeType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $activeModules = $options['active_modules'];

        $builder
            ->add('email', EmailType::class, [
                'label' => 'Votre email',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez entrer votre adresse email.'),
                    new Assert\Email(message: 'Adresse email invalide.'),
                ],
                'attr' => [
                    'class' => 'form-control',
                    'placeholder' => 'votre@email.fr',
                ],
            ]);

        if (in_array('blog', $activeModules, true)) {
            $builder->add('subscribeArticles', CheckboxType::class, [
                'required' => false,
                'label' => 'Nouveaux articles',
                'label_attr' => ['class' => 'form-check-label'],
                'attr' => ['class' => 'form-check-input'],
            ]);
        }

        if (in_array('events', $activeModules, true)) {
            $builder->add('subscribeEvents', CheckboxType::class, [
                'required' => false,
                'label' => 'Nouveaux evenements',
                'label_attr' => ['class' => 'form-check-label'],
                'attr' => ['class' => 'form-check-input'],
            ]);
        }

        // Honeypot anti-spam (meme pattern que ContactType)
        $builder->add('website', TextType::class, [
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
        $resolver->setDefaults([
            'data_class' => Subscriber::class,
            'active_modules' => [],
        ]);

        $resolver->setAllowedTypes('active_modules', 'array');
    }
}
