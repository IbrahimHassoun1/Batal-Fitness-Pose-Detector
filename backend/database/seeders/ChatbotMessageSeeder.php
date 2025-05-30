<?php

namespace Database\Seeders;

use App\Models\ChatbotSession;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;


class ChatbotMessageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        ChatbotSession::factory()
            ->count(10)
            ->create();
    }
}
