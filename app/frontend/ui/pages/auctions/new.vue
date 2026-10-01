<script setup lang="ts">
import { Head, useForm } from "@inertiajs/vue3"
import ParticipantBar from "../../components/ParticipantBar.vue"
import { composePublish } from "../../../composition"

const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000)
const local = new Date(tomorrow.getTime() - tomorrow.getTimezoneOffset() * 60000).toISOString().slice(0, 16)

const form = useForm({
  title: "",
  starting_price_cents: 1000,
  ends_at: local,
})
const publish = composePublish(form)

function submit() {
  publish.submit({
    title: form.title,
    startingPriceCents: form.starting_price_cents,
    endsAt: form.ends_at,
  })
}
</script>

<template>
  <Head title="Publicar leilão" />
  <ParticipantBar />
  <main>
    <h1>Publicar leilão</h1>
    <form @submit.prevent="submit">
      <label>
        Título
        <input v-model="form.title" name="title" required />
      </label>
      <label>
        Preço inicial (centavos)
        <input v-model.number="form.starting_price_cents" name="starting_price_cents" type="number" min="1" required />
      </label>
      <label>
        Término
        <input v-model="form.ends_at" name="ends_at" type="datetime-local" required />
      </label>
      <button type="submit" :disabled="form.processing">Publicar</button>
    </form>
  </main>
</template>
