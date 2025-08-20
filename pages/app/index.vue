<script setup lang="ts">
import ProtectedContent from "@/components/features/ProtectedContent.vue";
definePageMeta({
  middleware: "auth",
  layout: "authenticated",
});
</script>

<template>
  <ProtectedContent />
</template>
