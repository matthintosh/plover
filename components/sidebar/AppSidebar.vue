<script setup lang="ts">
import {
  Sidebar,
  SidebarHeader,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
} from "@/components/ui/sidebar";
import { Input } from "@/components/ui/input";
import { Avatar, AvatarImage, AvatarFallback } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";

const supabase = useSupabaseClient();

const handleLogout = async () => {
  await supabase.auth.signOut();
  window.location.href = "/login";
};

const itemsByGroup: {
  [key: string]: { title: string; url: string; icon: string }[];
} = {
  Application: [
    {
      title: "Accueil",
      url: "#",
      icon: "carbon:home",
    },
    {
      title: "Patients",
      url: "#",
      icon: "carbon:person-favorite",
    },

    {
      title: "Calendrier",
      url: "#",
      icon: "carbon:calendar",
    },
    {
      title: "Statistiques",
      url: "#",
      icon: "carbon:chart-pie",
    },
    {
      title: "Download",
      url: "#",
      icon: "carbon:download",
    },
  ],
  Information: [
    {
      title: "Aide",
      url: "#",
      icon: "carbon:help",
    },
    {
      title: "Paramètres",
      url: "#",
      icon: "carbon:settings",
    },
  ],
};
</script>

<template>
  <Sidebar>
    <SidebarHeader>
      <div class="flex items-center gap-2">
        <img src="~/assets/img/logo.svg" alt="logo" class="h-10 w-10" />
        <p class="text-lg font-bold">Plover</p>
      </div>
    </SidebarHeader>
    <SidebarContent>
      <SidebarGroup v-for="group in Object.keys(itemsByGroup)" :key="group">
        <SidebarGroupLabel>{{ group }}</SidebarGroupLabel>
        <SidebarMenu>
          <SidebarMenuItem
            v-for="item in itemsByGroup[group]"
            :key="item.title"
          >
            <SidebarMenuButton as-child>
              <a :href="item.url">
                <Icon :name="item.icon" />
                <span>{{ item.title }}</span>
              </a>
            </SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarGroup>
      <SidebarGroup>
        <SidebarGroupLabel>Rechercher</SidebarGroupLabel>
        <Input type="text" placeholder="Patient, dossier..." />
      </SidebarGroup>
    </SidebarContent>
    <SidebarFooter>
      <div class="flex items-center gap-2">
        <Avatar>
          <AvatarImage src="https://github.com/unovue.png" alt="@unovue" />
          <AvatarFallback>CN</AvatarFallback>
        </Avatar>
        <Button variant="ghost" @click="handleLogout">Se déconnecter</Button>
      </div>
    </SidebarFooter>
  </Sidebar>
</template>
