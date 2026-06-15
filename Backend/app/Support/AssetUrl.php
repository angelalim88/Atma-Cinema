<?php

namespace App\Support;

class AssetUrl
{
    public static function for(string $directory, ?string $filename, bool $preferStorage = false): ?string
    {
        if (!$filename) {
            return null;
        }

        if (filter_var($filename, FILTER_VALIDATE_URL)) {
            return $filename;
        }

        $publicRelativePath = $directory . '/' . ltrim($filename, '/');
        $storageRelativePath = 'storage/' . $publicRelativePath;

        if (file_exists(public_path($publicRelativePath))) {
            return url($publicRelativePath);
        }

        if (file_exists(public_path($storageRelativePath))) {
            return url($storageRelativePath);
        }

        return url($preferStorage ? $storageRelativePath : $publicRelativePath);
    }
}
