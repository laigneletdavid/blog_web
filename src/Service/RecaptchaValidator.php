<?php

namespace App\Service;

use Symfony\Contracts\HttpClient\HttpClientInterface;

/**
 * Validates Google reCAPTCHA v3 tokens server-side.
 * Disabled if RECAPTCHA_SECRET_KEY is empty (dev environment).
 */
class RecaptchaValidator
{
    private const VERIFY_URL = 'https://www.google.com/recaptcha/api/siteverify';
    private const MIN_SCORE = 0.5;

    public function __construct(
        private readonly HttpClientInterface $httpClient,
        private readonly string $recaptchaSecretKey,
        private readonly string $recaptchaSiteKey = '',
    ) {
    }

    public function isEnabled(): bool
    {
        return $this->recaptchaSecretKey !== '';
    }

    public function getSiteKey(): string
    {
        return $this->recaptchaSiteKey;
    }

    /**
     * Validates a reCAPTCHA v3 token.
     *
     * @return bool True if validation passes (or if reCAPTCHA is disabled)
     */
    public function validate(?string $token, string $expectedAction = 'contact'): bool
    {
        if (!$this->isEnabled()) {
            return true;
        }

        if (!$token || $token === '') {
            return false;
        }

        $response = $this->httpClient->request('POST', self::VERIFY_URL, [
            'body' => [
                'secret' => $this->recaptchaSecretKey,
                'response' => $token,
            ],
        ]);

        $data = $response->toArray(false);

        if (!($data['success'] ?? false)) {
            return false;
        }

        if (($data['action'] ?? '') !== $expectedAction) {
            return false;
        }

        if (($data['score'] ?? 0) < self::MIN_SCORE) {
            return false;
        }

        return true;
    }
}
