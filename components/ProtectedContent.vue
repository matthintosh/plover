<script setup lang="ts">
const supabase = useSupabaseClient();
const user = useSupabaseUser();

const logout = async () => {
  await supabase.auth.signOut();
  window.location.href = "/login";
};
</script>

<template>
  <div>
    <p>Welcome, {{ user?.email }}</p>
    <button @click="logout">Logout</button>
  </div>
</template>
