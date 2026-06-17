<?php

namespace App\Model;

use App\Enum\SeoStatus;

final class SeoReport
{
    /** @var SeoCheck[] */
    public readonly array $checks;
    public readonly SeoStatus $status;

    /**
     * @param SeoCheck[] $checks
     */
    public function __construct(array $checks)
    {
        $this->checks = $checks;
        $this->status = self::aggregate($checks);
    }

    /**
     * @param SeoCheck[] $checks
     */
    private static function aggregate(array $checks): SeoStatus
    {
        $hasRed = false;
        $hasOrange = false;

        foreach ($checks as $check) {
            if ($check->status === SeoStatus::RED) {
                $hasRed = true;
            } elseif ($check->status === SeoStatus::ORANGE) {
                $hasOrange = true;
            }
        }

        if ($hasRed) {
            return SeoStatus::RED;
        }

        if ($hasOrange) {
            return SeoStatus::ORANGE;
        }

        return SeoStatus::GREEN;
    }
}
