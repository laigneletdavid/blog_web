<?php

namespace App\Entity;

interface SanitizableContentInterface
{
    public function getBlocks(): ?array;

    public function getContent(): ?string;

    public function setContent(string $content): self;
}
