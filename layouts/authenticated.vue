<template>
  <div class="flex flex-col min-h-screen">
    <SidebarProvider>
      <AppSidebar />
      <main class="flex-1">
        <div class="p-2 h-full">
          <SidebarTrigger />
          <slot />
        </div>
      </main>
    </SidebarProvider>
  </div>
</template>

<script setup lang="ts">
import AppSidebar from "@/components/sidebar/AppSidebar.vue";
import { SidebarTrigger } from "@/components/ui/sidebar";
</script>
