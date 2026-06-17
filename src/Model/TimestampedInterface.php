<?php

namespace App\Model;

interface TimestampedInterface
{
    public function getCreatedAt();

    public function setCreatedAt(\DateTimeInterface $createdAt);

    public function getUpdatedAt();

    public function setUpdatedAt(?\DateTimeInterface $updatedAt);

}