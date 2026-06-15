<?php

namespace App\Model;

use App\Enum\SeoStatus;

final class SeoCheck
{
    public function __construct(
        public readonly string $key,
        public readonly string $label,
        public readonly SeoStatus $status,
        public readonly string $message,
        public readonly bool $critical = false,
    ) {
    }
}
