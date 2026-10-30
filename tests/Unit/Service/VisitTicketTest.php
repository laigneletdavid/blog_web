<?php

namespace App\Tests\Unit\Service;

use App\Service\VisitTicket;
use PHPUnit\Framework\TestCase;

class VisitTicketTest extends TestCase
{
    private VisitTicket $tickets;

    protected function setUp(): void
    {
        $this->tickets = new VisitTicket('secret-de-test');
    }

    public function testUnTicketValideRendSonChemin(): void
    {
        $ticket = $this->tickets->issue('/annuaire/cave-a-lier');

        $this->assertSame('/annuaire/cave-a-lier', $this->tickets->verify($ticket));
    }

    public function testUnTicketModifieEstRefuse(): void
    {
        $ticket = $this->tickets->issue('/annuaire');
        [, $signature] = explode('.', $ticket);
        $fabrique = base64_encode(time() . '|/page-inventee') . '.' . $signature;

        $this->assertNull($this->tickets->verify($fabrique));
    }

    public function testUnTicketSigneAvecUnAutreSecretEstRefuse(): void
    {
        $ticket = (new VisitTicket('autre-secret'))->issue('/annuaire');

        $this->assertNull($this->tickets->verify($ticket));
    }

    public function testUnTicketPerimeEstRefuse(): void
    {
        $ticket = $this->tickets->issue('/annuaire', 1_000_000);

        $this->assertSame('/annuaire', $this->tickets->verify($ticket, 1_000_000 + 600));
        $this->assertNull($this->tickets->verify($ticket, 1_000_000 + 601));
    }

    public function testUnTicketIllisibleEstRefuse(): void
    {
        $this->assertNull($this->tickets->verify(''));
        $this->assertNull($this->tickets->verify('pas-un-ticket'));
        $this->assertNull($this->tickets->verify('%%%.abc'));
    }
}
