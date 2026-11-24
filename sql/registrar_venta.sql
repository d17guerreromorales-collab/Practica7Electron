-- Práctica 6: venta atómica para Supabase/PostgreSQL.
-- Ejecuta este archivo en Supabase > SQL Editor.
-- La función usa permisos del invocador y conserva las reglas RLS existentes.

CREATE OR REPLACE FUNCTION public.registrar_venta(
  p_id_cliente uuid,
  p_id_producto uuid,
  p_cantidad bigint
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = public
AS $$
DECLARE
  v_precio double precision;
  v_total double precision;
  v_venta jsonb;
BEGIN
  IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
    RAISE EXCEPTION 'La cantidad debe ser mayor que cero.' USING ERRCODE = '22023';
  END IF;

  PERFORM 1 FROM public."Clientes" WHERE id_cliente = p_id_cliente;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'El cliente seleccionado no existe.' USING ERRCODE = '23503';
  END IF;

  -- La actualización condicional evita vender unidades concurrentemente por debajo de cero.
  UPDATE public."PRODUCTOS"
     SET existencia = existencia - p_cantidad
   WHERE id_producto = p_id_producto
     AND existencia >= p_cantidad
  RETURNING precio INTO v_precio;

  IF NOT FOUND THEN
    PERFORM 1 FROM public."PRODUCTOS" WHERE id_producto = p_id_producto;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'El producto seleccionado no existe.' USING ERRCODE = '23503';
    END IF;
    RAISE EXCEPTION 'Existencia insuficiente para completar la venta.' USING ERRCODE = '22023';
  END IF;

  IF v_precio IS NULL OR v_precio <= 0 THEN
    RAISE EXCEPTION 'El producto tiene un precio inválido.' USING ERRCODE = '22023';
  END IF;

  v_total := v_precio * p_cantidad;
  INSERT INTO public."VENTAS" AS nueva_venta (id_cliente, id_producto, cantidad, fecha_venta, total)
  VALUES (p_id_cliente, p_id_producto, p_cantidad, now(), v_total)
  RETURNING to_jsonb(nueva_venta) INTO v_venta;

  RETURN v_venta;
END;
$$;
