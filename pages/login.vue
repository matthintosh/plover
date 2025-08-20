<script setup lang="ts">
import LoginForm from "@/components/features/authentification/LoginForm.vue";
definePageMeta({
  middleware: "guest",
  layout: "guest",
});
</script>

<template>
  <LoginForm />
</template>
