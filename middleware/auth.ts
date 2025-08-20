export default defineNuxtRouteMiddleware((to) => {
  const user = useSupabaseUser();
  if (!user.value) {
    return navigateTo("/login");
  }
  if (to.path === "/") {
    return navigateTo("/app");
  }
});
