<script setup lang="ts">
import { Head } from "@inertiajs/vue3"
import ParticipantBar from "../../components/ParticipantBar.vue"
import { Money } from "../../../domain/money"

defineProps<{
  auctions: Array<{
    id: string
    title: string
    current_price_cents: number
    open: boolean
  }>
}>()
</script>

<template>
  <Head title="Casa de Leilões" />
  <ParticipantBar />
  <main>
    <h1>Leilões abertos</h1>
    <p v-if="auctions.length === 0">Nenhum leilão publicado.</p>
    <ul>
      <li v-for="auction in auctions" :key="auction.id">
        <a :href="`/auctions/${auction.id}`">{{ auction.title }}</a>
        <span>{{ Money.fromCents(auction.current_price_cents).format() }}</span>
        <span>{{ auction.open ? "aberto" : "encerrado" }}</span>
      </li>
    </ul>
  </main>
</template>
