<script setup lang="ts">
definePageMeta({
  middleware: "auth",
  layout: "authenticated",
});
</script>

<template>
  <ProtectedContent/>
</template>
