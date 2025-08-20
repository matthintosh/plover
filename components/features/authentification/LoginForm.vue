<script setup lang="ts">
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

const email = ref("");
const password = ref("");
const error = ref("");
const supabase = useSupabaseClient();

const login = async () => {
  error.value = "";
  const { error: loginError } = await supabase.auth.signInWithPassword({
    email: email.value,
    password: password.value,
  });
  if (loginError) {
    error.value = loginError.message;
  } else {
    navigateTo("/app");
  }
};
</script>

<template>
  <form class="w-full max-w-md" @submit.prevent="login">
    <Card class="w-full max-w-md">
      <CardHeader>
        <CardTitle class="flex items-center gap-2"
          ><img src="~/assets/img/logo.svg " alt="Plover" class="w-10 h-10" />
          <p class="text-2xl font-bold">Plover</p></CardTitle
        >
        <CardDescription>{{ $t("login.description") }}</CardDescription>
      </CardHeader>
      <CardContent class="flex flex-col gap-4">
        <div class="space-y-2">
          <Label for="email">{{ $t("login.email") }}</Label>
          <Input
            id="email"
            v-model="email"
            type="email"
            required
            autocomplete="username"
          />
        </div>
        <div class="space-y-2">
          <Label for="password">{{ $t("login.password") }}</Label>
          <Input
            id="password"
            v-model="password"
            type="password"
            required
            autocomplete="current-password"
          />
        </div>
        <div v-if="error" class="text-destructive text-sm">{{ error }}</div>
      </CardContent>
      <CardFooter>
        <Button
          type="submit"
          class="w-full bg-primary text-primary-foreground rounded-md py-2 font-medium"
          >{{ $t("login.login") }}</Button
        >
      </CardFooter>
    </Card>
  </form>
</template>
