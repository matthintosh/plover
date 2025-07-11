<script setup lang="ts">
definePageMeta({
  middleware: "auth",
  layout: "authenticated",
});
</script>

<template>
  <ProtectedContent>
    <div class="flex flex-col items-center justify-center h-screen">
      <h1 class="text-2xl font-bold">Welcome to the app</h1>
    </div>
  </ProtectedContent>
</template>
