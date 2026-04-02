<?php

namespace App\Controller\Admin;

use App\Entity\Order;
use App\Enum\OrderStatusEnum;
use App\Enum\PaymentMethodEnum;
use EasyCorp\Bundle\EasyAdminBundle\Config\Action;
use EasyCorp\Bundle\EasyAdminBundle\Config\Actions;
use EasyCorp\Bundle\EasyAdminBundle\Config\Crud;
use EasyCorp\Bundle\EasyAdminBundle\Config\Filters;
use EasyCorp\Bundle\EasyAdminBundle\Controller\AbstractCrudController;
use EasyCorp\Bundle\EasyAdminBundle\Field\ArrayField;
use EasyCorp\Bundle\EasyAdminBundle\Field\ChoiceField;
use EasyCorp\Bundle\EasyAdminBundle\Field\DateTimeField;
use EasyCorp\Bundle\EasyAdminBundle\Field\EmailField;
use EasyCorp\Bundle\EasyAdminBundle\Field\MoneyField;
use EasyCorp\Bundle\EasyAdminBundle\Field\NumberField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TelephoneField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextareaField;
use EasyCorp\Bundle\EasyAdminBundle\Field\TextField;
use EasyCorp\Bundle\EasyAdminBundle\Filter\ChoiceFilter;
use EasyCorp\Bundle\EasyAdminBundle\Filter\DateTimeFilter;
use Symfony\Component\Security\Http\Attribute\IsGranted;

#[IsGranted('ROLE_ADMIN')]
class OrderCrudController extends AbstractCrudController
{
    use Trait\AdminHelpTrait;

    public static function getEntityFqcn(): string
    {
        return Order::class;
    }

    public function configureCrud(Crud $crud): Crud
    {
        return $crud
            ->setEntityLabelInSingular('Commande')
            ->setEntityLabelInPlural('Commandes')
            ->setDefaultSort(['createdAt' => 'DESC'])
            ->setSearchFields(['reference', 'customerFirstName', 'customerLastName', 'customerEmail'])
            ->showEntityActionsInlined();
    }

    public function configureActions(Actions $actions): Actions
    {
        return $actions
            ->disable(Action::NEW, Action::DELETE)
            ->add(Crud::PAGE_INDEX, Action::DETAIL);
    }

    public function configureFilters(Filters $filters): Filters
    {
        return $filters
            ->add(ChoiceFilter::new('status')->setChoices(OrderStatusEnum::choices()))
            ->add(ChoiceFilter::new('paymentMethod')->setChoices(PaymentMethodEnum::choices()))
            ->add(DateTimeFilter::new('createdAt'));
    }

    public function configureFields(string $pageName): iterable
    {
        // Index
        yield TextField::new('reference', 'Reference');

        yield TextField::new('customerFullName', 'Client')
            ->hideOnForm();

        yield EmailField::new('customerEmail', 'Email')
            ->onlyOnDetail();

        yield TelephoneField::new('customerPhone', 'Telephone')
            ->onlyOnDetail();

        yield ChoiceField::new('status', 'Statut')
            ->setChoices(OrderStatusEnum::choices())
            ->renderAsBadges([
                'pending' => 'warning',
                'paid' => 'success',
                'cancelled' => 'secondary',
                'refunded' => 'info',
            ]);

        yield ChoiceField::new('paymentMethod', 'Paiement')
            ->setChoices(PaymentMethodEnum::choices())
            ->hideOnIndex();

        yield NumberField::new('totalTTC', 'Total TTC')
            ->setNumDecimals(2)
            ->formatValue(fn ($value) => number_format((float) $value, 2, ',', ' ') . ' €');

        yield DateTimeField::new('createdAt', 'Date')
            ->setFormat('dd/MM/yyyy HH:mm');

        yield DateTimeField::new('paidAt', 'Paye le')
            ->onlyOnDetail()
            ->setFormat('dd/MM/yyyy HH:mm');

        yield TextareaField::new('customerMessage', 'Message')
            ->onlyOnDetail();

        yield ArrayField::new('items', 'Articles')
            ->onlyOnDetail();

        yield NumberField::new('totalHT', 'Total HT')
            ->onlyOnDetail()
            ->setNumDecimals(2)
            ->formatValue(fn ($value) => number_format((float) $value, 2, ',', ' ') . ' €');

        yield NumberField::new('totalVAT', 'TVA')
            ->onlyOnDetail()
            ->setNumDecimals(2)
            ->formatValue(fn ($value) => number_format((float) $value, 2, ',', ' ') . ' €');

        yield TextField::new('stripeSessionId', 'Stripe Session')
            ->onlyOnDetail();
    }

    protected function getHelpData(): ?array
    {
        return [
            'title' => 'Aide — Commandes',
            'sections' => [
                [
                    'title' => 'Suivi des commandes',
                    'content' => '<p>Les commandes sont creees automatiquement lors du passage en caisse. Elles sont en <strong>lecture seule</strong> — vous ne pouvez pas les modifier ni en creer manuellement.</p>
                    <ul>
                        <li><strong>En attente</strong> — commande creee, paiement non recu</li>
                        <li><strong>Payee</strong> — paiement Stripe confirme</li>
                        <li><strong>Annulee</strong> — commande annulee</li>
                        <li><strong>Remboursee</strong> — remboursement effectue</li>
                    </ul>',
                ],
            ],
            'tips' => [
                'Les remboursements se font directement depuis votre dashboard Stripe.',
            ],
        ];
    }
}
