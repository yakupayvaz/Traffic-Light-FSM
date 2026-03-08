`timescale 1ns/1ps
module tb_Traffic_Light_FSM();
    logic clk;
    logic reset;
    logic TAORB;
    logic [2:0] LA, LB;

    // Modülü bağla
    Traffic_Light_FSM dut (
        .clk(clk),
        .reset(reset),
        .TAORB(TAORB),
        .LA(LA),
        .LB(LB)
    );

    // Saat Sinyali (100ns periyot)
    always #50 clk = ~clk;

    initial begin
        // Başlangıç Ayarları
        clk = 0;
        reset = 1;
        TAORB = 0;
        
        #150 reset = 0; // Sistemi resetten çıkar

        // --- SENARYO 1: A Yolu Dolu (S0'da Çakılı Kalma) ---
        #100 TAORB = 1; 
        #800;           // 800ns boyunca A yeşil kalmalı

        // --- SENARYO 2: A Yolu Boşaldı (Geçiş Başlar) ---
        #100 TAORB = 0; 
        #2500;          // Sarı (S1) ve Kırmızıya (S2) geçişi izle

        // --- SENARYO 3: B Yolu Yeşilken A'ya Yeni Araç Geldi ---
        // (Sistem hemen dönmemeli, güvenli geçişi tamamlamalı)
        #100 TAORB = 1;
        #1500;

        // --- SENARYO 4: Hızlı Değişim ---
        #100 TAORB = 0;
        #200 TAORB = 1;
        #200 TAORB = 0;

        #2000;
        $stop;
    end
endmodule