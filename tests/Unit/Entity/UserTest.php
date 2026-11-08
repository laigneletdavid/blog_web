<?php

namespace App\Tests\Unit\Entity;

use App\Entity\User;
use PHPUnit\Framework\TestCase;

class UserTest extends TestCase
{
    private function user(?string $firstName, ?string $name): User
    {
        return (new User())->setEmail('david@example.test')->setFirstName($firstName)->setName($name);
    }

    public function testDisplayNameWithFirstNameAndName(): void
    {
        self::assertSame('David Laignelet', $this->user('David', 'Laignelet')->getDisplayName());
    }

    public function testDisplayNameWithOnlyOnePart(): void
    {
        self::assertSame('David', $this->user('David', null)->getDisplayName());
        self::assertSame('Laignelet', $this->user(null, 'Laignelet')->getDisplayName());
    }

    public function testDisplayNameFallsBackToEmailWhenNamesAreNull(): void
    {
        self::assertSame('david@example.test', $this->user(null, null)->getDisplayName());
    }

    public function testDisplayNameIgnoresEmptyStrings(): void
    {
        // Cas reel : le formulaire enregistre '' quand le nom est laisse vide
        self::assertSame('david@example.test', $this->user('', '')->getDisplayName());
        self::assertSame('david@example.test', $this->user('  ', '')->getDisplayName());
        self::assertSame('Laignelet', $this->user('', 'Laignelet')->getDisplayName());
    }
}
