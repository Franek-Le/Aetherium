#include "interrupts.h"

void printf(char* str);

InterruptManager::GateDescriptor InterruptManager::InterruptDescriptorTable[256];

static void InterruptManager::SetInterruptDescriptorTableEntry(uint8_t interruptNumber, uint16_t codeSegmentSelectorOffset, void (*handler)(), uint8_t DescriptorPrivilegeLevel, uint8_t DescriptorType) {
  const uint8_t IDT_DESC_PRESENT = 0x80;
  
  InterruptDescriptorTable[interruptNumber].handlerAddressLowBits = ((uint32_t)handler) & 0xFFFF;
  InterruptDescriptorTable[interruptNumber].handlerAddressHighBits = (((uint32_t)handler) >> 16) & 0xFFFF;
  InterruptDescriptorTable[interruptNumber].gdt_codeSegmentSelector = codeSegmentSelectorOffset;
  InterruptDescriptorTable[interruptNumber].access = IDT_DESC_PRESENT | DescriptorType | ((DescriptorPrivilegeLevel&3) << 5);
  InterruptDescriptorTable[interruptNumber].reserved = 0;

}

InterruptManager::InterruptManager(GlobalDescriptorTable* gdt) {
  uint16_t CodeSegment = gdt->CodeSegmentSelector();
  const uint8_t IDT_INTERRUPT_GATE = 0xE;

  for (uint16_t i = 0; i < 256; i++)
    SetInterruptDescriptorTableEntry(i, CodeSegment, &IgnoreInterruptRequest, 0, IDT_INTERRUPT_GATE);

    SetInterruptDescriptorTableEntry(0x20, CodeSegment, &HandleInterruptRequest0x00, 0, IDT_INTERRUPT_GATE);
    SetInterruptDescriptorTableEntry(0x21, CodeSegment, &HandleInterruptRequest0x01, 0, IDT_INTERRUPT_GATE);

    InterruptDescriptorTablePointer idt;
    idt.size = 256 * sizeof(GateDescriptor) - 1;
    idt.base = (uint32_t)InterruptDescriptorTable;
    asm volatile("lidt %0" : : "m" (idt));
}

InterruptManager::~InterruptManager() {}

void InterruptManager::Activate() {
  asm("sti");
}

static uint32_t InterruptManager::HandleInterrupt(uint8_t interruptNumber, uint32_t esp) {
  
  printf("INTERRUPT");
  
  return esp;
}