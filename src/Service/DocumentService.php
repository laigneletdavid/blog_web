<?php

namespace App\Service;

class DocumentService
{
    public const MAX_FILE_SIZE_BYTES = 25 * 1024 * 1024; // 25 Mo

    public const ALLOWED_EXTENSIONS = [
        'pdf',
        'doc', 'docx',
        'xls', 'xlsx',
        'ppt', 'pptx',
        'odt', 'ods', 'odp',
        'zip', 'rar', '7z',
        'csv', 'txt',
    ];

    public function __construct(
        private readonly string $documentDirectory,
    ) {
    }

    public function isAllowedExtension(string $extension): bool
    {
        return in_array(strtolower($extension), self::ALLOWED_EXTENSIONS, true);
    }

    /**
     * "1.2 Mo", "340 Ko", "12 octets".
     */
    public function formatSize(?int $bytes): string
    {
        if ($bytes === null || $bytes <= 0) {
            return '';
        }

        if ($bytes < 1024) {
            return $bytes . ' octets';
        }

        if ($bytes < 1024 * 1024) {
            return number_format($bytes / 1024, 0, ',', ' ') . ' Ko';
        }

        return number_format($bytes / (1024 * 1024), 1, ',', ' ') . ' Mo';
    }

    /**
     * Classe FontAwesome correspondant a l'extension.
     */
    public function iconForExtension(?string $extension): string
    {
        $ext = strtolower((string) $extension);

        return match ($ext) {
            'pdf' => 'fa-file-pdf',
            'doc', 'docx', 'odt' => 'fa-file-word',
            'xls', 'xlsx', 'ods', 'csv' => 'fa-file-excel',
            'ppt', 'pptx', 'odp' => 'fa-file-powerpoint',
            'zip', 'rar', '7z' => 'fa-file-archive',
            'txt' => 'fa-file-lines',
            default => 'fa-file',
        };
    }

    public function getDocumentDirectory(): string
    {
        return $this->documentDirectory;
    }
}
