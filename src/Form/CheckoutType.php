<?php

namespace App\Form;

use App\Enum\PaymentMethodEnum;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\EmailType;
use Symfony\Component\Form\Extension\Core\Type\TelType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Validator\Constraints as Assert;

class CheckoutType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $builder
            ->add('firstName', TextType::class, [
                'label' => 'Prenom',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez saisir votre prenom.'),
                    new Assert\Length(max: 255),
                ],
                'attr' => ['placeholder' => 'Votre prenom', 'autocomplete' => 'given-name'],
            ])
            ->add('lastName', TextType::class, [
                'label' => 'Nom',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez saisir votre nom.'),
                    new Assert\Length(max: 255),
                ],
                'attr' => ['placeholder' => 'Votre nom', 'autocomplete' => 'family-name'],
            ])
            ->add('email', EmailType::class, [
                'label' => 'Email',
                'constraints' => [
                    new Assert\NotBlank(message: 'Veuillez saisir votre email.'),
                    new Assert\Email(message: 'Veuillez saisir un email valide.'),
                ],
                'attr' => ['placeholder' => 'votre@email.com', 'autocomplete' => 'email'],
            ])
            ->add('phone', TelType::class, [
                'label' => 'Telephone',
                'required' => false,
                'constraints' => [
                    new Assert\Length(max: 50),
                ],
                'attr' => ['placeholder' => '06 12 34 56 78', 'autocomplete' => 'tel'],
            ])
            ->add('message', TextareaType::class, [
                'label' => 'Message (optionnel)',
                'required' => false,
                'constraints' => [
                    new Assert\Length(max: 1000),
                ],
                'attr' => ['placeholder' => 'Informations complementaires, date souhaitee...', 'rows' => 3],
            ])
            ->add('paymentMethod', ChoiceType::class, [
                'label' => 'Mode de paiement',
                'choices' => $this->buildPaymentChoices($options['stripe_configured']),
                'expanded' => true,
                'data' => $options['stripe_configured'] ? PaymentMethodEnum::STRIPE->value : PaymentMethodEnum::MANUAL->value,
                'constraints' => [
                    new Assert\NotBlank(),
                ],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'stripe_configured' => false,
        ]);
    }

    private function buildPaymentChoices(bool $stripeConfigured): array
    {
        $choices = [];

        if ($stripeConfigured) {
            $choices['Carte bancaire (paiement securise)'] = PaymentMethodEnum::STRIPE->value;
        }

        $choices['Virement / cheque / especes'] = PaymentMethodEnum::MANUAL->value;

        return $choices;
    }
}
