import { Controller, NotImplementedException } from '@nestjs/common';
import { MessagePattern, Payload } from '@nestjs/microservices';

import { CreateOrderDto } from './dto/create-order.dto';
import { OrdersService } from './orders.service';

@Controller()
export class OrdersController {
  constructor(private readonly ordersService: OrdersService) {}

  // @MessagePattern({ cmd: 'createOrder' })
  // create(@Payload() createOrderDto: CreateOrderDto) {
  //   // return this.ordersService.create(createOrderDto);
  // }

  @MessagePattern({ cmd: 'findAllOrders' })
  findAll() {
    return this.ordersService.findAll();
  }

  @MessagePattern({ cmd: 'findOneOrder' })
  findOne(@Payload() payload: { id: number }) {
    return this.ordersService.findOne(payload.id);
  }

  // @MessagePattern({ cmd: 'changeOrderStatus' })
  // changeOrderStatus() {
  //   // return this.ordersService.changeStatus();

  //   throw new NotImplementedException();
  // }
}
