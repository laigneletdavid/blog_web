<?php

namespace App\Entity;

use App\Repository\MediaRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: MediaRepository::class)]
class Media
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $name = null;

    #[ORM\Column(length: 255)]
    private ?string $file_name = null;

    #[ORM\Column(length: 255, nullable: true)]
    private ?string $alt_text = null;

    #[ORM\Column(length: 10)]
    private ?string $extention = null;

    #[ORM\ManyToMany(targetEntity: Tag::class, mappedBy: 'media')]
    private Collection $tag;

    public function __construct()
    {
        $this->tag = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getName(): ?string
    {
        return $this->name;
    }

    public function setName(string $name): self
    {
        $this->name = $name;

        return $this;
    }

    public function getFileName(): ?string
    {
        return $this->file_name;
    }

    public function setFileName(string $file_name): self
    {
        $this->file_name = $file_name;

        return $this;
    }

    public function getAltText(): ?string
    {
        return $this->alt_text;
    }

    public function setAltText(?string $alt_text): self
    {
        $this->alt_text = $alt_text;

        return $this;
    }

    public function getExtention(): ?string
    {
        return $this->extention;
    }

    public function setExtention(string $extention): self
    {
        $this->extention = $extention;

        return $this;
    }

    /**
     * @return Collection<int, Tag>
     */
    public function getTag(): Collection
    {
        return $this->tag;
    }

    public function addTag(Tag $tag): self
    {
        if (!$this->tag->contains($tag)) {
            $this->tag->add($tag);
            $tag->addMedium($this);
        }

        return $this;
    }

    public function removeTag(Tag $tag): self
    {
        if ($this->tag->removeElement($tag)) {
            $tag->removeMedium($this);
        }

        return $this;
    }
}
