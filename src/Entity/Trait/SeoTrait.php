<?php

namespace App\Entity\Trait;

use Doctrine\ORM\Mapping as ORM;
use Symfony\Component\Validator\Constraints as Assert;

trait SeoTrait
{
    #[ORM\Column(length: 70, nullable: true)]
    #[Assert\Length(max: 70, maxMessage: 'Le titre SEO ne peut pas depasser {{ limit }} caracteres.')]
    private ?string $seoTitle = null;

    #[ORM\Column(length: 160, nullable: true)]
    #[Assert\Length(max: 160, maxMessage: 'La meta description ne peut pas depasser {{ limit }} caracteres.')]
    private ?string $seoDescription = null;

    #[ORM\Column(length: 255, nullable: true)]
    #[Assert\Length(max: 255)]
    private ?string $seoKeywords = null;

    #[ORM\Column(type: 'boolean', options: ['default' => false])]
    private bool $noIndex = false;

    #[ORM\Column(length: 255, nullable: true)]
    #[Assert\Length(max: 255)]
    #[Assert\Url(message: 'L\'URL canonique doit etre une URL valide.')]
    private ?string $canonicalUrl = null;

    public function getSeoTitle(): ?string
    {
        return $this->seoTitle;
    }

    public function setSeoTitle(?string $seoTitle): self
    {
        $this->seoTitle = $seoTitle;

        return $this;
    }

    public function getSeoDescription(): ?string
    {
        return $this->seoDescription;
    }

    public function setSeoDescription(?string $seoDescription): self
    {
        $this->seoDescription = $seoDescription;

        return $this;
    }

    public function getSeoKeywords(): ?string
    {
        return $this->seoKeywords;
    }

    public function setSeoKeywords(?string $seoKeywords): self
    {
        $this->seoKeywords = $seoKeywords;

        return $this;
    }

    public function isNoIndex(): bool
    {
        return $this->noIndex;
    }

    public function setNoIndex(bool $noIndex): self
    {
        $this->noIndex = $noIndex;

        return $this;
    }

    public function getCanonicalUrl(): ?string
    {
        return $this->canonicalUrl;
    }

    public function setCanonicalUrl(?string $canonicalUrl): self
    {
        $this->canonicalUrl = $canonicalUrl;

        return $this;
    }
}
