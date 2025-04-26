#include "xparameters.h"
#include "xgpio.h"
#include "sleep.h"

// Replace with the actual device ID or use LookupConfig if required by your Vitis version
#define GPIO_DEVICE_ID  XPAR_AXI_GPIO_0_DEVICE_ID
#define GPIO_CHANNEL    1  // Channel 1 is usually output

int main() {
    int status;
    XGpio Gpio;

    // Initialize the GPIO driver
    status = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
    if (status != XST_SUCCESS) {
        xil_printf("GPIO Initialization Failed\r\n");
        return XST_FAILURE;
    }

    // Set the direction for all signals to outputs
    XGpio_SetDataDirection(&Gpio, GPIO_CHANNEL, 0x0);

    // Main control loop
    while (1) {
        // Rread the processed value from DSP.
        // Since the DSP output is directly wired to the GPIO, just toggle or set the GPIO pin.
        // For demonstration, we'll toggle the output every second.

        // Example: Set pump ON (assuming active-high logic)
        XGpio_DiscreteWrite(&Gpio, GPIO_CHANNEL, 1);
        sleep(1); // 1 second ON

        // Example: Set pump OFF
        XGpio_DiscreteWrite(&Gpio, GPIO_CHANNEL, 0);
        sleep(1); // 1 second OFF

        // In real application, replace the above with logic to set the GPIO
        // based on the processed viscosity value, e.g.:
        // uint32_t pump_ctrl_value = ... // get from DSP or memory-mapped register
        // XGpio_DiscreteWrite(&Gpio, GPIO_CHANNEL, pump_ctrl_value & 0x1);
    }

    return 0;
}
