<template>
  <div class="flex min-h-screen">
    <SidebarProvider>
      <AppSidebar />
      <!-- Main content -->
      <main class="flex-1">
        <SidebarTrigger />
        <slot />
      </main>
    </SidebarProvider>
  </div>
</template>

<script setup lang="ts">
import AppSidebar from "@/components/sidebar/AppSidebar.vue";
import { SidebarTrigger } from "@/components/ui/sidebar";
</script>
