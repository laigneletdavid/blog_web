<?php

namespace App\Service;

use App\Entity\Menu;
use App\Entity\Site;
use App\Repository\MenuRepository;
use Doctrine\ORM\EntityManagerInterface;

class MenuSyncService
{
    public function __construct(
        private readonly MenuRepository $menuRepository,
        private readonly ThemeService $themeService,
        private readonly EntityManagerInterface $em,
    ) {
    }

    /**
     * Sync all menu zones from theme.yaml into the database.
     *
     * @return array{created: int, updated: int, hidden: int}
     */
    public function syncAllZones(Site $site): array
    {
        $enabledModules = $site->getEnabledModules();
        $zones = $this->themeService->getMenuZones($site->getTemplate());

        $stats = ['created' => 0, 'updated' => 0, 'hidden' => 0];

        foreach ($zones as $location => $zoneConfig) {
            $items = $zoneConfig['items'] ?? [];
            $result = $this->syncZone($location, $items, $enabledModules);
            $stats['created'] += $result['created'];
            $stats['updated'] += $result['updated'];
            $stats['hidden'] += $result['hidden'];
        }

        $this->em->flush();

        return $stats;
    }

    /**
     * Sync a single menu zone.
     *
     * @param array<array{system_key: string, name: string, route: string, route_params?: array, module?: string}> $items
     * @param string[] $enabledModules
     * @return array{created: int, updated: int, hidden: int}
     */
    public function syncZone(string $location, array $items, array $enabledModules): array
    {
        $stats = ['created' => 0, 'updated' => 0, 'hidden' => 0];

        foreach ($items as $order => $itemConfig) {
            $systemKey = $itemConfig['system_key'];
            $hasModule = isset($itemConfig['module']);
            $moduleActive = !$hasModule || in_array($itemConfig['module'], $enabledModules, true);

            $existing = $this->menuRepository->findSystemByLocationAndKey($location, $systemKey);

            if ($existing !== null) {
                // Update route/params (always), visibility depends on module
                $existing->setRoute($itemConfig['route']);
                $existing->setRouteParams($itemConfig['route_params'] ?? null);

                if ($hasModule) {
                    $existing->setIsVisible($moduleActive);
                    if (!$moduleActive) {
                        $stats['hidden']++;
                    }
                }

                $stats['updated']++;
            } else {
                // Create new system menu item
                $menu = new Menu();
                $menu->setName($itemConfig['name']);
                $menu->setLocation($location);
                $menu->setIsSystem(true);
                $menu->setSystemKey($systemKey);
                $menu->setRoute($itemConfig['route']);
                $menu->setRouteParams($itemConfig['route_params'] ?? null);
                $menu->setTarget('route');
                $menu->setMenuOrder($order * 10);
                $menu->setIsVisible($moduleActive);

                $this->em->persist($menu);
                $stats['created']++;
            }
        }

        return $stats;
    }

    /**
     * Hide all system menu items linked to a specific module.
     */
    public function hideModuleItems(string $moduleName): int
    {
        $count = 0;
        $systemItems = $this->menuRepository->findBy(['is_system' => true]);

        foreach ($systemItems as $item) {
            // Check if this item's route corresponds to the module
            // We look at the theme.yaml to find items with this module
            $zones = $this->themeService->getMenuZones();
            foreach ($zones as $zoneConfig) {
                foreach ($zoneConfig['items'] ?? [] as $itemConfig) {
                    if (
                        ($itemConfig['system_key'] ?? '') === $item->getSystemKey()
                        && ($itemConfig['module'] ?? null) === $moduleName
                        && $item->getLocation() === $this->findLocationForSystemKey($itemConfig['system_key'], $zones)
                    ) {
                        $item->setIsVisible(false);
                        $count++;
                    }
                }
            }
        }

        $this->em->flush();

        return $count;
    }

    /**
     * Show all system menu items linked to a specific module.
     */
    public function showModuleItems(string $moduleName): int
    {
        $count = 0;
        $zones = $this->themeService->getMenuZones();

        foreach ($zones as $location => $zoneConfig) {
            foreach ($zoneConfig['items'] ?? [] as $itemConfig) {
                if (($itemConfig['module'] ?? null) !== $moduleName) {
                    continue;
                }

                $existing = $this->menuRepository->findSystemByLocationAndKey(
                    $location,
                    $itemConfig['system_key']
                );

                if ($existing !== null) {
                    $existing->setIsVisible(true);
                    $count++;
                }
            }
        }

        $this->em->flush();

        return $count;
    }

    private function findLocationForSystemKey(string $systemKey, array $zones): ?string
    {
        foreach ($zones as $location => $zoneConfig) {
            foreach ($zoneConfig['items'] ?? [] as $item) {
                if (($item['system_key'] ?? '') === $systemKey) {
                    return $location;
                }
            }
        }

        return null;
    }
}
