<script setup lang="ts">
import { router, usePage } from "@inertiajs/vue3"
import { composeSession } from "../../composition"

type Participant = { id: string; name: string; role: string }

const page = usePage<{
  participant: Participant | null
  participants: Participant[]
  flash: { alert: string | null; notice: string | null }
}>()

const session = composeSession(router)

function choose(id: string) {
  session.choose(id)
}
</script>

<template>
  <header class="bar">
    <a href="/">Casa de Leilões</a>
    <nav>
      <a href="/auctions/new">Publicar</a>
      <label>
        Participante
        <select
          :value="page.props.participant?.id"
          @change="choose(($event.target as HTMLSelectElement).value)"
        >
          <option v-for="person in page.props.participants" :key="person.id" :value="person.id">
            {{ person.name }}
          </option>
        </select>
      </label>
    </nav>
    <p v-if="page.props.flash?.alert" class="alert">{{ page.props.flash.alert }}</p>
  </header>
</template>
