<template>
  <div class="flex flex-col min-h-screen">
    <div
      class="w-full flex items-center gap-2 h-14 fixed top-0 left-0 right-0 z-50 px-4 backdrop-blur-lg border-b border-gray-500/10"
    >
      <img src="~/assets/img/logo.svg" alt="logo" >
      <Button variant="ghost" class="hover:bg-gray-500/10">
        <Icon name="carbon:home" /> Accueil
      </Button>
      <Button variant="ghost" class="hover:bg-gray-500/10">
        <Icon name="carbon:calendar" /> Calendrier
      </Button>
      <Button variant="ghost" class="hover:bg-gray-500/10">
        <Icon name="carbon:chart-pie" /> Statistiques
      </Button>
      <Button variant="ghost" class="hover:bg-gray-500/10">
        <Icon name="carbon:download" /> Télécharger
      </Button>
      <Input type="text" placeholder="Search" class="w-ful" />
      <Button variant="ghost" class="hover:bg-gray-500/10">
        <Icon name="carbon:help" /> Aide
      </Button>
      <Button variant="ghost" class="hover:bg-gray-500/10">
        <Icon name="carbon:settings" /> Paramètres
      </Button>
      <Avatar>
        <AvatarImage src="https://github.com/unovue.png" alt="@unovue" />
        <AvatarFallback>CN</AvatarFallback>
      </Avatar>
    </div>
    <div class="flex-1 mt-14">
      <slot />
    </div>
  </div>
</template>
