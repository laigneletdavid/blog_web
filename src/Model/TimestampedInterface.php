<?php

namespace App\Model;

interface TimestampedInterface
{
    public function getCreatedAt();

    public function setCreatedAt(\DateTimeInterface $created_at);

    public function getUpdatedAt();

    public function setUpdatedAt(?\DateTimeInterface $updated_at);

}