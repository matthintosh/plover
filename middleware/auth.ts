export default defineNuxtRouteMiddleware((to, from) => {
  console.log(to, from);
  const user = useSupabaseUser();
  if (!user.value) {
    return navigateTo("/login");
  }
  if (to.path === "/") {
    return navigateTo("/app");
  }
});
